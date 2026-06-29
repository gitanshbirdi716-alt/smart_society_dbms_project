USE smart_society;

CREATE OR REPLACE VIEW v_block_occupancy AS
SELECT
  f.block,
  COUNT(f.flat_no) AS total_flats,
  COUNT(r.flat_no) AS occupied_flats,
  ROUND(COUNT(r.flat_no) * 100.0 / NULLIF(COUNT(f.flat_no), 0), 1) AS occupancy_percent
FROM flats f
LEFT JOIN residents r ON f.flat_no = r.flat_no
GROUP BY f.block;

CREATE OR REPLACE VIEW v_monthly_collections AS
SELECT
  DATE_FORMAT(COALESCE(payment_date, due_date), '%Y-%m') AS month,
  COUNT(*) AS total_invoices,
  SUM(CASE WHEN status = 'Paid' THEN amount ELSE 0 END) AS paid_amount,
  SUM(CASE WHEN status IN ('Pending', 'Overdue') THEN amount ELSE 0 END) AS pending_amount
FROM maintenance_payments
GROUP BY DATE_FORMAT(COALESCE(payment_date, due_date), '%Y-%m')
ORDER BY month DESC;

CREATE OR REPLACE VIEW v_overdue_residents AS
SELECT
  r.resident_id,
  r.name,
  r.flat_no,
  r.phone,
  COUNT(p.payment_id) AS overdue_count,
  SUM(p.amount) AS overdue_amount
FROM residents r
JOIN maintenance_payments p ON p.resident_id = r.resident_id
WHERE p.status IN ('Overdue', 'Pending')
  AND p.due_date < CURDATE()
GROUP BY r.resident_id, r.name, r.flat_no, r.phone
ORDER BY overdue_amount DESC;

CREATE OR REPLACE VIEW v_dashboard_stats AS
SELECT
  (SELECT COUNT(*) FROM flats) AS total_flats,
  (SELECT COUNT(*) FROM residents) AS total_residents,
  (SELECT COUNT(*) FROM maintenance_payments WHERE status = 'Pending') AS pending_payments,
  (SELECT COUNT(*) FROM maintenance_payments WHERE status = 'Overdue') AS overdue_payments,
  (SELECT COUNT(*) FROM complaints WHERE status NOT IN ('Resolved', 'Closed')) AS open_complaints,
  (SELECT COUNT(*) FROM visitors WHERE exit_time IS NULL) AS current_visitors,
  (SELECT COUNT(*) FROM parking) AS total_parking_slots;
