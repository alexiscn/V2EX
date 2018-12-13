#!/usr/bin/env python
# -*- coding: utf-8 -*-
# https://github.com/iv-mexx/update_localization/blob/master/update_localization.py

'''
Usage

cd honeyapp/
'''

import re
import os
import sys
import tempfile
import subprocess
import codecs
import optparse
import shutil
import logging
import doctest


class LocalizedStringLineParser(object):
    def __init__(self):
        # Possible Parsing states indicating what is waited for
        self.ParseStates = {'COMMENT': 1, 'STRING': 2, 'TRAILING_COMMENT': 3,
                            'STRING_MULTILINE': 4, 'COMMENT_MULTILINE': 5}
        # The parsing state indicates what the last parsed thing was
        self.parse_state = self.ParseStates['COMMENT']
        self.key = None
        self.value = None
        self.comment = None

    def parse_line(self, line):
        if self.parse_state == self.ParseStates['COMMENT']:
            (self.key, self.value, self.comment) = LocalizedString.parse_trailing_comment(line)
            if self.key is not None and self.value is not None and self.comment is not None:
                return self.build_localizedString()
            self.comment = LocalizedString.parse_comment(line)
            if self.comment is not None:
                self.parse_state = self.ParseStates['STRING']
                return None
            # Maybe its a multiline comment
            self.comment_partial = LocalizedString.parse_multiline_comment_start(line)
            if self.comment_partial is not None:
                self.parse_state = self.ParseStates['COMMENT_MULTILINE']
            return None

        elif self.parse_state == self.ParseStates['COMMENT_MULTILINE']:
            comment_end = LocalizedString.parse_multiline_comment_end(line)
            if comment_end is not None:
                self.comment = self.comment_partial + '\n' + comment_end
                self.comment_partial = None
                self.parse_state = self.ParseStates['STRING']
                return None
            # Or its just an intermediate line
            comment_line = LocalizedString.parse_multiline_comment_line(line)
            if comment_line is not None:
                self.comment_partial = self.comment_partial + '\n' + comment_line
            return None

        elif self.parse_state == self.ParseStates['TRAILING_COMMENT']:
            self.comment = LocalizedString.parse_comment(line)
            if self.comment is not None:
                self.parse_state = self.ParseStates['COMMENT']
                return self.build_localizedString()
            return None

        elif self.parse_state == self.ParseStates['STRING']:
            (self.key, self.value) = LocalizedString.parse_localized_pair(
                line
            )
            if self.key is not None and self.value is not None:
                self.parse_state = self.ParseStates['COMMENT']
                return self.build_localizedString()
            # Otherwise, try if the Value is multi-line
            (self.key, self.value_partial) = LocalizedString.parse_multiline_start(
                line
            )
            if self.key is not None and self.value_partial is not None:
                self.parse_state = self.ParseStates['STRING_MULTILINE']
                self.value = None
            return None
        elif self.parse_state == self.ParseStates['STRING_MULTILINE']:
            value_part = LocalizedString.parse_multiline_end(line)
            if value_part is not None:
                self.value = self.value_partial + '\n' + value_part
                self.value_partial = None
                self.parse_state = self.ParseStates['COMMENT']
                return self.build_localizedString()
            value_part = LocalizedString.parse_multiline_line(line)
            if value_part is not None:
                self.value_partial = self.value_partial + '\n' + value_part
            return None

    def build_localizedString(self):
        localizedString = LocalizedString(
            self.key,
            self.value,
            self.comment
        )
        self.key = None
        self.value = None
        self.comment = None
        return localizedString


class LocalizedString(object):
    ''' A localizes string entry with key, value and comment'''

    COMMENT_EXPR = re.compile('^\w*/\* (?P<comment>.+) \*/\w*$')
    COMMENT_MULTILINE_START = re.compile('^\w/\* (?P<comment>.+)\w*$')
    COMMENT_MULTILINE_LINE = re.compile('^(?P<comment>.+)$')
    COMMENT_MULTILINE_END = re.compile('^(?P<comment>.+)\*/\s*$')
    LOCALIZED_STRING_EXPR = re.compile('^"(?P<key>.+)" ?= ?"(?P<value>.+)";$')
    LOCALIZED_STRING_MULTILINE_START_EXPR = re.compile('^"(?P<key>.+)" ?= ?"(?P<value>.+)$')
    LOCALIZED_STRING_MULTILINE_LINE_EXPR = re.compile('^(?P<value>.+)$')
    LOCALIZED_STRING_MULTILINE_END_EXPR = re.compile('^(?P<value>.+)" ?; ?$')
    LOCALIZED_STRING_TRAILING_COMMENT_EXPR = re.compile('^"(?P<key>.+)" ?= ?"(?P<value>.+)" ?; ?/\* (?P<comment>.+) \*/$')

    @classmethod
    def parse_multiline_start(cls, line):

        result = cls.LOCALIZED_STRING_MULTILINE_START_EXPR.match(line)
        if result is not None:
            return (result.group('key'),
                    result.group('value'))
        else:
            return (None, None)

    @classmethod
    def parse_multiline_line(cls, line):
        result = cls.LOCALIZED_STRING_MULTILINE_LINE_EXPR.match(line)
        if result is not None:
            return result.group('value')
        return None


    @classmethod
    def parse_multiline_end(cls, line):
        result = cls.LOCALIZED_STRING_MULTILINE_END_EXPR.match(line)
        if result is not None:
            return result.group('value')
        return None

    @classmethod
    def parse_trailing_comment(cls, line):
        result = cls.LOCALIZED_STRING_TRAILING_COMMENT_EXPR.match(line)
        if result is not None:
            return (
                result.group('key'),
                result.group('value'),
                result.group('comment')
            )
        else:
            return (None, None, None)


    @classmethod
    def parse_multiline_comment_start(cls, line):
        result = cls.COMMENT_MULTILINE_START.match(line)
        if result is not None:
            return result.group('comment')
        else:
            return None

    @classmethod
    def parse_multiline_comment_line(cls, line):
        result = cls.COMMENT_MULTILINE_LINE.match(line)
        if result is not None:
            return result.group('comment')
        else:
            return None

    @classmethod
    def parse_multiline_comment_end(cls, line):
        result = cls.COMMENT_MULTILINE_END.match(line)
        if result is not None:
            return result.group('comment')
        else:
            return None


    @classmethod
    def parse_comment(cls, line):
        result = cls.COMMENT_EXPR.match(line)
        if result is not None:
            return result.group('comment')
        else:
            return None

    @classmethod
    def parse_localized_pair(cls, line):
        result = cls.LOCALIZED_STRING_EXPR.match(line)
        if result is not None:
            return (
                result.group('key'),
                result.group('value')
            )
        else:
            return (None, None)

    def __eq__(self, other):
        if isinstance(other, LocalizedString):
            return (self.key == other.key and self.value == other.value and
                    self.comment == other.comment)
        else:
            return NotImplemented

    def __neq__(self, other):
        result = self.__eq__(other)
        if (result is NotImplemented):
            return result
        return not result

    def __init__(self, key, value=None, comment=None):
        super(LocalizedString, self).__init__()
        self.key = key
        self.value = value
        self.comment = comment

    def is_raw(self):
        return self.value == self.key

    def __str__(self):
        if self.comment:
            return '/* %s */\n"%s" = "%s";\n' % (
                self.comment, self.key or '', self.value or '',
            )
        else:
            return '"%s" = "%s";\n' % (self.key or '', self.value or '')


# -- Methods -------------------------------------------------------------------

ENCODINGS = ['utf16', 'utf8']

def merge_strings(old_strings, new_strings, keep_comment=False):
    merged_strings = {}
    for key, old_string in old_strings.iteritems():
        if key in new_strings:
            new_string = new_strings[key]
            if old_string.is_raw():
                # if the old string is raw just take the new string
                if keep_comment:
                    new_string.comment = old_string.comment
                merged_strings[key] = new_string
            else:
                # otherwise take the value of the old string but the comment of the new string
                new_string.value = old_string.value
                if keep_comment:
                    new_string.comment = old_string.comment
                merged_strings[key] = new_string
            # remove the string from the new strings
            del new_strings[key]
        else:
            # If the String is not in the new Strings anymore it has been removed
            # TODO: Include option to not remove old keys!
            pass
    # All strings that are still in the new_strings dict are really new and can be copied
    for key, new_string in new_strings.iteritems():
        merged_strings[key] = new_string

    return merged_strings


def parse_file(file_path, encoding='utf16'):
    with codecs.open(file_path, mode='r', encoding=encoding) as file_contents:
        logging.debug("Parsing File: {}".format(file_path))
        parser = LocalizedStringLineParser()
        localized_strings = {}
        try:
            for line in file_contents:
                localized_string = parser.parse_line(line)
                if localized_string is not None:
                    localized_strings[localized_string.key] = localized_string
        except UnicodeError:
            logging.debug("Failed to open file as UTF16, Trying UTF8")
            file_contents = codecs.open(file_path, mode='r', encoding='utf8')
            for line in file_contents:
                localized_string = parser.parse_line(line)
                if localized_string is not None:
                    localized_strings[localized_string.key] = localized_string
    return localized_strings


def write_file(file_path, strings, encoding='utf16'):
    '''Writes the strings to the given file
    '''
    with codecs.open(file_path, 'w', encoding) as output:
        for string in sort_strings(strings):
            output.write('%s\n' % string)


def strings_to_file(localized_strings, file_path, encoding='utf16'):
    with codecs.open(file_path, 'w', encoding) as output:
        for localized_string in sort_strings(localized_strings):
            output.write('%s\n' % localized_string)


def sort_strings(strings):
    keys = strings.keys()
    keys.sort()

    values = []
    for key in keys:
        values.append(strings[key])

    return values


def find_sources(folder_path, extensions=None, ignore_patterns=None):
    # First run genstrings on all source-files
    code_file_paths = []
    if extensions is None:
        extensions = frozenset(['c', 'm', 'mm', 'swift'])

    for dir_path, dir_names, file_names in os.walk(folder_path):
        ignorePath = False
        if ignore_patterns is not None:
            for ignore_pattern in ignore_patterns:
                if ignore_pattern in dir_path:
                    logging.debug('IGNORED Path: {}'.format(dir_path))
                    ignorePath = True
        if ignorePath is False:
            logging.debug('DirPath: {}'.format(dir_path))
            for file_name in file_names:
                extension = file_name.rpartition('.')[2]
                if extension in extensions:
                    code_file_path = os.path.join(dir_path, file_name)
                    code_file_paths.append(code_file_path)
    logging.info('Found %d files', len(code_file_paths))
    return code_file_paths


def gen_strings(folder_path, gen_path=None, extensions=None, ignore_patterns=None):
    code_file_paths = find_sources(folder_path, extensions, ignore_patterns)

    if gen_path is None:
        gen_path = code_file_paths

    logging.debug('Running genstrings')
    temp_folder_path = tempfile.mkdtemp()

    arguments = ['genstrings', '-u', '-o', temp_folder_path]
    arguments.extend(code_file_paths)
    subprocess.call(arguments)
    logging.debug('Temp Path: {}'.format(temp_folder_path))

    # Read the Strings from the new generated strings
    for temp_file in os.listdir(temp_folder_path):
        # For each file (which is a single Table) read the corresponding existing file and combine them
        logging.debug('Temp File found: {}'.format(temp_file))
        temp_file_path = os.path.join(temp_folder_path, temp_file)
        current_file_path = os.path.join(gen_path, temp_file)
        merge_files(temp_file_path, current_file_path, gen_path)
        os.remove(temp_file_path)
    shutil.rmtree(temp_folder_path)


def merge_files(new_file_path, old_file_path, folder_path, keep_comment=False):
    new_strings = parse_file(new_file_path)
    logging.debug('Current File: {}'.format(old_file_path))
    if os.path.exists(old_file_path):
        logging.debug('File Exists, merge them')
        print('File Exists, merge them')
        old_strings = parse_file(old_file_path)
        final_strings = merge_strings(old_strings, new_strings, keep_comment)
        write_file(old_file_path, final_strings, 'utf8')
    else:
        logging.info('File {} is new'.format(new_file_path))
        if not os.path.exists(folder_path):
            logging.info('Creating path {} because it does not exist yet.'.format(folder_path))
            os.makedirs(folder_path)
        shutil.copy(new_file_path, folder_path)


def main():
    parser = optparse.OptionParser(
        'usage: %prog [options] [output folder] [source folders] [ignore patterns]'
    )
    parser.add_option(
        '-i', '--input', action='store', dest='input_path', default='.', help='Input Path where the Source-Files are'
    )
    parser.add_option(
        '-o', '--output', action='store', dest='output_path', default='.', help='Output Path where the .strings File should be generated'
    )
    parser.add_option(
        '-v', '--verbose', action='store_true', dest='verbose', default=False, help='Show debug messages'
    )
    parser.add_option(
        '', '--unittests', action='store_true', dest='unittests', default=False, help='Run unit tests (debug)'
    )
    parser.add_option(
        '--ignore', action='append', dest='ignore_patterns', default=None, help='Ignore Paths that match the patterns'
    )
    parser.add_option(
        '--extension', action='append', dest='extensions', default=None, help='File-Extensions that should be scanned'
    )

    (options, args) = parser.parse_args()

    # Create Logger
    logging.basicConfig(
        format='%(message)s', level=options.verbose and logging.DEBUG or logging.INFO
    )

    # Run Unittests/Doctests
    if options.unittests:
        doctest.testmod()
        return

    gen_strings(folder_path=options.input_path,
                gen_path=options.output_path,
                extensions=options.extensions,
                ignore_patterns=options.ignore_patterns)

    return 0

if __name__ == '__main__':
    sys.exit(main())