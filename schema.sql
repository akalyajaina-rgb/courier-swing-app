-- ============================================================
-- Courier & Parcel Tracking System - Database Schema (MySQL)
-- ============================================================

CREATE DATABASE IF NOT EXISTS courier_db;
USE courier_db;

CREATE TABLE admin (
    admin_id   INT AUTO_INCREMENT PRIMARY KEY,
    username   VARCHAR(50)  NOT NULL UNIQUE,
    password   VARCHAR(100) NOT NULL
);

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    email       VARCHAR(100) UNIQUE,
    phone       VARCHAR(15),
    password    VARCHAR(100) NOT NULL,
    address     VARCHAR(255)
);

CREATE TABLE delivery_staff (
    staff_id        INT AUTO_INCREMENT PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    phone           VARCHAR(15),
    status          ENUM('AVAILABLE','BUSY') DEFAULT 'AVAILABLE',
    assigned_count  INT DEFAULT 0          -- current active-parcel load, used for load balancing
);

CREATE TABLE parcels (
    parcel_id        INT AUTO_INCREMENT PRIMARY KEY,
    customer_id      INT NOT NULL,
    staff_id         INT,
    pickup_address   VARCHAR(255) NOT NULL,
    delivery_address VARCHAR(255) NOT NULL,
    weight_kg        DECIMAL(6,2),
    status           ENUM('BOOKED','ASSIGNED','PICKED_UP','IN_TRANSIT','DELIVERED') DEFAULT 'BOOKED',
    booking_date     DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (staff_id) REFERENCES delivery_staff(staff_id)
);

CREATE TABLE tracking_history (
    history_id   INT AUTO_INCREMENT PRIMARY KEY,
    parcel_id    INT NOT NULL,
    status       VARCHAR(50) NOT NULL,
    location     VARCHAR(255),
    update_time  DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parcel_id) REFERENCES parcels(parcel_id)
);

-- Indexes to speed up the two hottest lookups (tracking + reports)
CREATE INDEX idx_tracking_parcel ON tracking_history(parcel_id, update_time);
CREATE INDEX idx_parcel_customer ON parcels(customer_id);
CREATE INDEX idx_parcel_status   ON parcels(status);

-- Sample seed data
INSERT INTO admin (username, password) VALUES ('admin', 'admin123');
INSERT INTO delivery_staff (name, phone) VALUES
 ('Ravi Kumar', '9000000001'),
 ('Anu Das',    '9000000002'),
 ('Suresh P',   '9000000003');
