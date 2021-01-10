#!/usr/bin/env python3

from argparse import ArgumentParser
import csv
from dataclasses import dataclass
from decimal import Decimal
from datetime import date, datetime
import json
import sys

from typing import List


@dataclass
class Transaction:
    """A single transaction from a bank or other statement."""

    date: date
    description: str
    debit_amount: Decimal
    credit_amount: Decimal


class Category:
    def __init__(self, name: str, description_patterns: List[str]):
        self.name = name
        self.description_patterns = [pat.lower() for pat in description_patterns]

    def matches(self, tx: Transaction):
        tx_desc = tx.description.lower()
        return any(pat in tx_desc for pat in self.description_patterns)


# Standard columns in a CSV export from Lloyds Bank.
LLOYDS_STATEMENT_COLUMNS = [
    "Transaction Date",
    "Transaction Type",
    "Sort Code",
    "Account Number",
    "Transaction Description",
    "Debit Amount",
    "Credit Amount",
    "Balance",
]


def parse_lloyds_statement(statement_csv_file):
    """
    Parse a transaction CSV file in the format exported by Lloyds Bank.

    The expected set of fields is:

      Date, Type, Sort Code, Account Number, Description, Debit Amount, Credit Amount, Balance
    """
    transactions = []
    tx_reader = csv.reader(statement_csv_file)

    header_row = next(tx_reader)
    if header_row != LLOYDS_STATEMENT_COLUMNS:
        raise Exception("Statement header columns do not match expected columns")

    for row in tx_reader:
        (
            date,
            type_,
            sort_code,
            account_code,
            desc,
            debit_amount,
            credit_amount,
            balance,
        ) = row
        parsed_date = datetime.strptime(date, "%d/%m/%Y").date()
        tx = Transaction(
            date=parsed_date,
            description=desc,
            debit_amount=Decimal(debit_amount) if debit_amount else Decimal(),
            credit_amount=Decimal(credit_amount) if credit_amount else Decimal(),
        )
        transactions.append(tx)
    return transactions


def parse_categories(categories_json):
    category_rules = json.load(categories_json)["categories"]

    categories = []
    for cat_json in category_rules:
        cat = Category(
            name=cat_json["category"], description_patterns=cat_json["description"]
        )
        categories.append(cat)
    return categories


def category_matches(transaction, categories):
    return [cat for cat in categories if cat.matches(transaction)]


if __name__ == "__main__":
    parser = ArgumentParser(description="Bank transaction analyzer")
    parser.add_argument("categories", help="JSON file containing categories")
    parser.add_argument("transactions", help="CSV file containing transactions")
    parser.add_argument(
        "--list-categories",
        dest="list_categories",
        action="store_true",
        help="List transaction categories",
    )
    parser.add_argument(
        "--select-categories",
        dest="select_categories",
        type=str,
        help="Comma-separated list of transaction categories to include",
    )
    args = parser.parse_args()

    transactions = parse_lloyds_statement(open(args.transactions))
    categories = parse_categories(open(args.categories))

    category_from_name = {}
    for cat in categories:
        category_from_name[cat.name] = cat

    if args.list_categories:
        cat_names = sorted(cat.name for cat in categories)
        for name in cat_names:
            print(name)
        sys.exit(0)

    # Filter transactions by category if `--select-categories` is specified.
    if args.select_categories:
        filter_categories = set(
            category_from_name[cat] for cat in args.select_categories.split(",")
        )
        transactions = [
            tx
            for tx in transactions
            if set(category_matches(tx, categories)) & filter_categories
        ]

    # Classify transactions.
    category_transactions = {}
    unknown_tx_descriptions = {}
    multiple_category_tx_descriptions = {}

    for tx in transactions:
        cat = category_matches(tx, categories)
        if len(cat) > 1:
            multiple_category_tx_descriptions[tx.description] = cat

        if not len(cat):
            cat_name = "Unknown"
            if not tx.description in unknown_tx_descriptions:
                unknown_tx_descriptions[tx.description] = []
            unknown_tx_descriptions[tx.description].append(tx)
        else:
            cat_name = cat[0].name

        if not cat_name in category_transactions:
            category_transactions[cat_name] = []
        category_transactions[cat_name].append(tx)

    # List transactions that could not be categorized.
    if len(multiple_category_tx_descriptions):
        print(
            f"\n{len(multiple_category_tx_descriptions)} transactions matched multiple categories:"
        )
        for desc in sorted(multiple_category_tx_descriptions.keys()):
            categories = ", ".join(
                c.name for c in multiple_category_tx_descriptions[desc]
            )
            print(f"  {desc}: {categories}")

    if len(unknown_tx_descriptions):
        print(f"\n{len(unknown_tx_descriptions)} transactions with unknown category:")
        for desc in sorted(unknown_tx_descriptions.keys()):
            txs = unknown_tx_descriptions[desc]
            debit_total = sum(tx.debit_amount for tx in txs)
            credit_total = sum(tx.credit_amount for tx in txs)

            totals = []
            if debit_total > 0:
                totals.append(f"{debit_total} out")
            if credit_total > 0:
                totals.append(f"{credit_total} in")

            print(f"  {desc}: {', '.join(totals)}")

    # Print transaction totals.
    print(f"\nTransaction totals by sender/receiver:")
    tx_descriptions = set(tx.description for tx in transactions)
    for desc in sorted(tx_descriptions):
        txs = [tx for tx in transactions if tx.description == desc]
        txs = sorted(txs, key=lambda tx: tx.date)

        debit_total = sum(tx.debit_amount for tx in txs)
        credit_total = sum(tx.credit_amount for tx in txs)

        totals = []
        if debit_total > 0:
            totals.append(f"{debit_total} out")
        if credit_total > 0:
            totals.append(f"{credit_total} in")

        first_tx_date = txs[0].date.strftime("%d/%m/%y")
        last_tx_date = txs[-1].date.strftime("%d/%m/%y")

        if first_tx_date == last_tx_date:
            date_range = first_tx_date
        else:
            date_range = f"{first_tx_date}-{last_tx_date}"

        print(f"  {desc} ({len(txs)}): {', '.join(totals)}. {date_range}")

    # Print category totals.
    print(f"\nCategory totals:")
    cat_names = sorted(category_transactions.keys())
    for cat_name in cat_names:
        cat_txs = category_transactions[cat_name]

        debit_total = sum(tx.debit_amount for tx in cat_txs)
        credit_total = sum(tx.credit_amount for tx in cat_txs)

        totals = []
        if debit_total > 0:
            totals.append(f"{debit_total} out")
        if credit_total > 0:
            totals.append(f"{credit_total} in")

        print(f"   {cat_name}: {', '.join(totals)}")
