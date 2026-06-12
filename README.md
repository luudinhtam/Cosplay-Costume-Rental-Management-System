````markdown
# Cosplay Costume Rental Management System

## Overview

The **Cosplay Costume Rental Management System** is a database-driven application designed to manage cosplay costume rental operations efficiently. The system supports inventory management, rental reservations, payment tracking, and business reporting in a centralized platform.

This project is developed as part of a **Database Management Systems** course and focuses on designing and implementing a relational database using **Microsoft SQL Server**.

---

## Objectives

- Manage cosplay costume inventory and availability.
- Support rental reservations and order processing.
- Track customer rental history.
- Manage payments and rental fees.
- Generate reports and business analytics.
- Ensure data consistency through relational database design.

---

## Actors

### Customer
- Browse costumes by category, character, size, or theme.
- View costume details and availability.
- Create rental reservations.
- Manage rental orders (extend, cancel, return).
- View payment history.

### Shop Staff
- Manage costume inventory.
- Confirm and process rental orders.
- Handle costume check-out and return.
- Inspect costume conditions.
- Update costume status.

### Administrator
- Manage users and staff accounts.
- Configure pricing policies.
- Monitor system transactions.
- Generate reports and statistics.

---

## Main Features

### Costume Management
- Add, update, and remove costumes.
- Manage costume sizes, variants, and categories.
- Track costume status:
  - Available
  - Rented
  - Maintenance

### Rental Management
- Create rental orders.
- Check costume availability.
- Extend or cancel reservations.
- Process returns.

### Payment Management
- Record rental payments.
- Manage deposits and late fees.
- View payment history.

### Reporting & Analytics
- Revenue reports.
- Costume utilization reports.
- Customer rental history.
- Late return reports.
- Maintenance reports.
- Popular character/theme statistics.

---

## Business Rules

1. Each costume has a unique ID.
2. A costume cannot be rented by more than one customer during the same rental period.
3. A customer can have multiple rental orders but cannot exceed the maximum number of active rentals.
4. Every rental order must contain at least one costume.
5. Rental fees are calculated based on rental duration and pricing policies.
6. Late returns generate penalty fees.
7. Every rental transaction must have an associated payment record.
8. Costumes under maintenance cannot be rented or reserved.

---

## Database Deliverables

- Entity Relationship Diagram (ERD)
- Relational Schema
- Functional Dependencies
- Database Normalization (1NF, 2NF, 3NF)
- SQL Scripts
- Sample Data
- Stored Procedures
- Triggers
- Reports and Queries

---

## Technology Stack

| Component | Technology |
|------------|------------|
| Database | Microsoft SQL Server |
| Query Language | T-SQL |
| Database Design | ERD & Relational Modeling |
| Version Control | Git & GitHub |

---

## Project Structure



---

## Reports

The system provides the following reports:

* Costume Utilization Report
* Revenue Report (Daily, Weekly, Monthly)
* Customer Rental History
* Most Popular Characters/Themes
* Late Return and Penalty Report
* Inventory Condition and Maintenance Report

---

## Team

Database Management Systems Course Project

**Project Title:** Cosplay Costume Rental Management System

**Database Platform:** Microsoft SQL Server

```
```
