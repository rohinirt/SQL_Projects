# Credit Card Fraud Detection Using SQL

## Overview

This project analyzes credit card transaction data to identify and investigate potentially fraudulent activity. Through structured SQL queries, patterns such as abnormal transaction behavior, rapid repeat purchases, unusual spending times, and deviations from standard customer behavior are surfaced. The analysis aids in proactively flagging suspicious transactions that merit deeper review.

## Objective

The primary objective of this project is to detect anomalies and potentially fraudulent credit card transactions using SQL-based analysis. By examining behavioral patterns across cardholders, merchants, and timeframes, we aim to pinpoint inconsistencies or red flags such as:

* Transactions significantly above the average spend for a cardholder or merchant.
* Usage patterns inconsistent with typical transaction times (e.g., late-night or weekend activity).
* Multiple high-value transactions in short time intervals.
* Cardholders transacting at new or unfamiliar merchants frequently.

## Dataset Description

The dataset consists of five interrelated tables:

### 1. `trans`

* `id`: Unique transaction identifier
* `card`: Card number used in the transaction
* `amount`: Transaction amount
* `trans_date`: Date of the transaction
* `trans_time`: Time of the transaction
* `id_merchant`: ID of the merchant involved

### 2. `credit_card`

* `card`: Credit card number
* `id_card_holder`: Reference to the cardholder who owns the card

### 3. `card_holder`

* `id_card_holder`: Unique identifier for each cardholder
* `holder_name`: Name of the cardholder

### 4. `merchant`

* `id_merchant`: Unique identifier for the merchant
* `merchant_name`: Name of the merchant
* `id_merchant_category`: Category ID assigned to the merchant

### 5. `merchant_category`

* `id_merchant_category`: Unique identifier for merchant category
* `category_name`: Category name (e.g., Groceries, Travel, Electronics)
(er_diagram.png)


## Conclusion

By leveraging SQL queries across transactional, customer, and merchant data, this project surfaces actionable insights that are critical to fraud detection. It highlights outliers and patterns that deviate from typical behavior, helping fraud analysts or automated systems flag high-risk activities. This foundational analysis can be integrated into broader fraud detection frameworks or systems for continuous monitoring and protection.

