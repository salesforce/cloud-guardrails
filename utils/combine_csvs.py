#! /usr/bin/env python
import os
import glob
import pandas as pd


def combine_csvs():
    csv_folder = os.path.abspath(os.path.join(os.path.dirname(__file__), os.path.pardir, "docs"))
    file = os.path.join(csv_folder, "all_policies.csv")
    os.chdir(csv_folder)
    extension = 'csv'
    # Remove the existing file first
    # file = "all_policies.csv"
    if os.path.exists(file):
        print(f"Removing the previous file: {file}")
        os.remove(file)
    # Create a list of the files that we want to combine
    all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
    # combine all files in the list
    combined_csv = pd.concat([pd.read_csv(f) for f in all_filenames])
    combined_csv.sort_values(by=["Service", "Policy Definition"], inplace=True)
    # export to csv
    combined_csv.drop_duplicates(subset="Policy Definition", keep=False, inplace=False)
    combined_csv.to_csv(file, index=False, encoding='utf-8-sig')


if __name__ == '__main__':
    combine_csvs()
