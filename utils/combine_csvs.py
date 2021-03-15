#! /usr/bin/env python
import os
import glob
import pandas as pd


def combine_csvs():
    csv_folder = os.path.join(os.path.dirname(__file__), os.path.pardir, "docs")
    os.chdir(csv_folder)
    extension = 'csv'
    all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
    # combine all files in the list
    combined_csv = pd.concat([pd.read_csv(f) for f in all_filenames])
    combined_csv.sort_values(by=["Service", "Policy Definition"], inplace=True)
    file = "all_policies.csv"
    if os.path.exists(file):
        print(f"Removing the previous file: {file}")
        os.remove(file)
    # export to csv
    combined_csv.to_csv(file, index=False, encoding='utf-8-sig')


if __name__ == '__main__':
    combine_csvs()
