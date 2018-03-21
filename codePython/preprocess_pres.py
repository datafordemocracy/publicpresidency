'''
Author: Gautam Somappa
Python code to read presedential documents,process and chunk data into different columns.
Data is stored in a CSV file called 'presDocument.csv'. File is uploaded in box under the folder processed_files.
'''

import glob
import datefinder
import re
from string import punctuation
import csv
import json
path = "/Users/gautam/Box Sync/presidency_project/presdoc/docs/*.txt"


def break_content(content,value):
    try:
        column_name = content.split(value)[1]
        column_name = column_name.rstrip('. \n')
        column_name = column_name.lstrip(':')
        content = content.split(value)[0]
    except:
        column_name = ""
        content = content
    return content,column_name
def time_match(content):
    regex = r"(Jan(uary)?|Feb(ruary)?|Mar(ch)?|Apr(il)?|May|Jun(e)?|Jul(y)?|Aug(ust)?|Sep(tember)?|Oct(ober)?|Nov(ember)?|Dec(ember)?)\s+\d{1,2},\s+\d{4}"
    matches = re.search(regex, content)
    return matches.group(0)


def main():
    final_data = {}
    count=0
    for filename in glob.glob(path):
        data={}
        file_object  = open(filename, 'r')
        filename = filename.split('/')[-1]
        blacklist = ['CHECKLIST','NOMINATIONS','DIGEST','ACTSAPPROVED']
        if  any(re.findall(r'|'.join(blacklist), filename, re.IGNORECASE))==False:
            data['index'] = str(count+1)
            data['Filename'] = str(filename)
            content = file_object.read()
            content,data['DCPD'] = break_content(content,'DCPD Number:')
            content,data['Subject'] = break_content(content,'Subjects:')
            content,data['Names'] = break_content(content,'Names:')
            content,data['Location'] = break_content(content,'Locations:')
            content,data['Categories'] = break_content(content,'Categories')
            content,data['Note'] = break_content(content,'NOTE:')
            time = time_match(content)
            data['Time Posted'] = str(time)
            title,text = break_content(content,time)
            if count == 128:
                print (filename)
                print (text)
            data['Title'] = title.split('\n')[2]
            text = text.replace(',', '')
            text = text.replace('\n', '')
            data['text'] = text
            if count ==128:
                print(data['text'])
            final_data[count]=data
            count+=1
    header = list(data.keys())
    with open('presDocument.csv', 'w+') as f:
        writer = csv.DictWriter(f, fieldnames=header)
        writer.writeheader()
        for i in final_data.values():
            writer.writerow(i)

main()
