UPDATE employee
SET employment_status = true
WHERE id IN (1, 3, 5, 7); -- Employed employees

UPDATE employee
SET employment_status = false
WHERE id IN (2, 4, 6); -- Not employed employees
