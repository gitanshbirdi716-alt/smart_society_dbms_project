USE smart_society;

CREATE TABLE IF NOT EXISTS flats (
  flat_no INT PRIMARY KEY,
  block VARCHAR(10) NOT NULL,
  floor INT NOT NULL,
  type VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS residents (
  resident_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  email VARCHAR(100) UNIQUE,
  flat_no INT NOT NULL,
  move_in_date DATE,
  CONSTRAINT fk_resident_flat FOREIGN KEY (flat_no) REFERENCES flats(flat_no)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS maintenance_payments (
  payment_id INT AUTO_INCREMENT PRIMARY KEY,
  amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
  payment_date DATE,
  due_date DATE NOT NULL,
  status ENUM('Paid', 'Pending', 'Overdue') NOT NULL,
  resident_id INT NOT NULL,
  CONSTRAINT fk_payment_resident FOREIGN KEY (resident_id) REFERENCES residents(resident_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS complaints (
  complaint_id INT AUTO_INCREMENT PRIMARY KEY,
  complaint_type VARCHAR(50) NOT NULL,
  description TEXT NOT NULL,
  status ENUM('Open', 'In Progress', 'Resolved', 'Closed') NOT NULL,
  complaint_date DATE NOT NULL,
  resident_id INT NOT NULL,
  CONSTRAINT fk_complaint_resident FOREIGN KEY (resident_id) REFERENCES residents(resident_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS visitors (
  visitor_id INT AUTO_INCREMENT PRIMARY KEY,
  visitor_name VARCHAR(100) NOT NULL,
  entry_time DATETIME NOT NULL,
  exit_time DATETIME NULL,
  purpose VARCHAR(255) NOT NULL,
  flat_no INT NOT NULL,
  CONSTRAINT fk_visitor_flat FOREIGN KEY (flat_no) REFERENCES flats(flat_no)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS parking (
  parking_id INT AUTO_INCREMENT PRIMARY KEY,
  slot_number VARCHAR(20) NOT NULL UNIQUE,
  vehicle_number VARCHAR(20) NOT NULL UNIQUE,
  vehicle_type ENUM('Car', 'Bike', 'Scooter', 'Other') NOT NULL,
  resident_id INT NULL,
  CONSTRAINT fk_parking_resident FOREIGN KEY (resident_id) REFERENCES residents(resident_id)
    ON UPDATE CASCADE ON DELETE SET NULL
);

INSERT IGNORE INTO flats (flat_no, block, floor, type) VALUES
  (101, 'A', 1, '2BHK'),
  (102, 'A', 1, '3BHK'),
  (201, 'B', 2, '2BHK'),
  (202, 'B', 2, '1BHK');

INSERT IGNORE INTO residents (resident_id, name, phone, email, flat_no, move_in_date) VALUES
  (1, 'Rahul Sharma', '9876543210', 'rahul@example.com', 101, '2025-01-15'),
  (2, 'Priya Singh', '9876543211', 'priya@example.com', 102, '2025-02-20');

INSERT IGNORE INTO maintenance_payments (payment_id, amount, payment_date, due_date, status, resident_id) VALUES
  (1, 2500.00, '2026-01-05', '2026-01-10', 'Paid', 1),
  (2, 2500.00, NULL, '2026-02-10', 'Pending', 2);

INSERT IGNORE INTO complaints (complaint_id, complaint_type, description, status, complaint_date, resident_id) VALUES
  (1, 'Water', 'Low pressure in kitchen tap', 'Open', '2026-02-01', 1);

INSERT IGNORE INTO visitors (visitor_id, visitor_name, entry_time, exit_time, purpose, flat_no) VALUES
  (1, 'Aman Verma', '2026-03-01 10:00:00', '2026-03-01 11:30:00', 'Delivery', 101);

INSERT IGNORE INTO parking (parking_id, slot_number, vehicle_number, vehicle_type, resident_id) VALUES
  (1, 'P-01', 'DL01AB1234', 'Car', 1),
  (2, 'P-02', 'DL02CD5678', 'Bike', 2);
