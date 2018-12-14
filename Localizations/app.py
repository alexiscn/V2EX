#!/usr/bin/env python
# -*- coding: utf-8 -*-

import codecs
from copy import copy
import os
import localization
import subprocess
import shutil
from googletrans import Translator

# Path for your project
BUNDLE_FOLDER_PATH = '../V2EX/'
# Path for Localizable.strings
LANGUAGES_PATH = '../V2EX/Supporting Files/'
# Path for new Localizable.strings
OUTPUT_PATH = './langs'


def translate(language):
    srcLanguage = 'en'
    destLanguage = {'zh-Hans':'zh-CN', 'en':'en'}
    if srcLanguage == destLanguage[language]:
        print('No need to translate')
        pass
    else:
        new_strings = localization.parse_file(old_file_path)
        for key, new_string in new_strings.iteritems():
            new_string.value = new_string.comment
            
        localization.write_file(old_file_path, new_strings)

        # old_strings = localization.parse_file(old_file_path_back)
        # keys_need_translate = []
        # for key, new_string in new_strings.iteritems():
        #     if key not in old_strings:
        #         keys_need_translate.append(key)
        # translator = Translator()
        # translations = translator.translate(keys_need_translate, dest=destLanguage[language], src=srcLanguage);
        # autotranslations = {}

        # for translation in translations:
        #     new_strings[translation.origin].value = translation.text
        #     autotranslations[translation.origin] = new_strings[translation.origin]
        # # print(translation.origin, ' -> ', translation.text)
        # localization.write_file(old_file_path, new_strings)

        # print('%s Translation complete' % language)


if __name__ == '__main__':
    if not os.path.exists(OUTPUT_PATH):
        os.mkdir(OUTPUT_PATH)

    # NOTE: make sure that your install `SwiftGenStrings` correctly
    # find all NSLocalizedStrings in your projects and export to OUTPUT_PATH
    cmd = 'find %s -name "*.swift" | xargs SwiftGenStrings -o %s' % (BUNDLE_FOLDER_PATH, OUTPUT_PATH) 
    subprocess.call(cmd, shell=True)

    # Translate each language and merge with original Localizable.strings
    new_file_path = os.path.join(OUTPUT_PATH, 'Localizable.strings')
    languages = os.listdir(LANGUAGES_PATH)
    for language in languages:
        if len(language) > 4 and language[-5:] == "lproj":        
            lang = language[:(len(language) -6)]
            if lang == "Base":
                continue

            folder_path = os.path.join(LANGUAGES_PATH, language)    
            old_file_path = os.path.join(folder_path, 'Localizable.strings')
            # make up a copy of original old strings files
            old_file_path_back = os.path.join(OUTPUT_PATH, lang + '.Localizable.strings.old')
            shutil.copy(old_file_path, old_file_path_back)
            # merge
            localization.merge_files(new_file_path, old_file_path, folder_path)

            translate(lang)
            print('%s done' % lang)


        

