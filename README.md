# Cosplay Costume Rental Management System

## Introduction

The **Cosplay Costume Rental Management System** is a database management project developed for academic purposes. The system is designed to support the management of a cosplay costume rental shop by digitizing rental operations, inventory management, customer management, and payment processing.

Instead of handling rental records manually, the system stores all information in a relational database, ensuring data consistency, efficient transaction processing, and easier reporting.

---

## Project Objectives

The project aims to:

* Design a normalized relational database for a costume rental business.
* Manage customers, staff, costumes, rental orders, and payments.
* Prevent rental conflicts through availability management.
* Support business rules using database constraints.
* Generate useful reports for business analysis.

---

## Problem Statement

As cosplay culture continues to grow, costume rental services face several challenges:

* Manual inventory tracking
* Rental scheduling conflicts
* Difficult payment management
* Poor customer rental history management
* Lack of business reports

This system addresses these problems by providing a centralized database-driven solution.

---

## System Features

### Customer

* Browse costumes by category, character, theme, or size
* View costume details and images
* Check costume availability
* Create rental reservations
* Extend, cancel, or return rental orders
* View payment history

### Shop Staff

* Manage costume inventory
* Process rental orders
* Check-out costumes
* Process returns
* Inspect costume condition
* Update costume status

### Administrator

* Manage customers and staff accounts
* Configure pricing policies
* Monitor system activities
* Generate business reports
* Analyze rental performance

---

## Business Rules

The system follows these business rules:

* Each costume has a unique identifier.
* One costume cannot be rented by multiple customers during the same period.
* A customer may have multiple rental orders but cannot exceed the maximum number of active rentals.
* Every rental order must contain at least one costume.
* Rental fees are calculated based on rental duration and pricing policy.
* Late returns generate penalty fees.
* Every rental order must have a corresponding payment record.
* Costumes under maintenance cannot be rented or reserved.

---

## Database Entities

The database consists of the following main entities:

* USER
* COSTUME
* COSTUME_IMAGE
* COSTUME_ITEM
* RENTAL_ORDER
* ORDER_ITEM
* PAYMENT
* PRICING_POLICY

These entities are connected through primary keys and foreign keys to maintain data integrity.

---

## Reports

The system supports several management reports, including:

* Costume utilization report
* Customer rental history
* Revenue report
* Popular cosplay characters/themes
* Late return report
* Costume maintenance report

---

## Technologies Used

* **Database:** Microsoft SQL Server
* **Language:** SQL
* **Modeling:** ER Diagram, Relational Schema
* **Documentation:** Microsoft Word / Markdown
* **Version Control:** Git & GitHub

---

## Database Design

The project includes:

* Entity Relationship Diagram (ERD)
* Relational Schema
* Functional Dependencies
* Candidate Keys
* Primary & Foreign Keys
* Normalization (up to 3NF)
* SQL Scripts

  * Table Creation
  * Constraints
  * Views
  * Indexes
  * Sample Data
  * Queries
  * Reports

---

## Learning Outcomes

Through this project, the team applied concepts of Database Management Systems, including:

* Database design
* Normalization
* SQL programming
* Views
* Indexes
* Constraints
* Data integrity
* Query optimization
* Report generation

---

## Project Structure

| File | Description |
|------|-------------|
| CreateDatabase.sql | Creates the project database. |
| CreateTables.sql | Creates all tables, primary keys, foreign keys, and constraints. |
| Data.sql | Inserts sample data for testing. |
| Functions.sql | Contains user-defined functions for business logic. |
| Procedures.sql | Contains stored procedures for rental management and transactions. |
| Triggers.sql | Implements automatic business rules and data validation. |
| Views.sql | Creates views for simplifying complex queries and reporting. |
| Indexes.sql | Creates indexes to improve query performance. |
| Queries.sql | Contains example queries and statistical reports. |

---

## Future Improvements

Possible future enhancements include:

* Online booking system
* QR code for costume check-in/check-out
* Mobile application
* Recommendation system
* Customer review and rating
* Real-time inventory dashboard

---

## Authors

Developed as a university Introduction to Databases course project.

---

## License

This project is created **for educational purposes only**.
