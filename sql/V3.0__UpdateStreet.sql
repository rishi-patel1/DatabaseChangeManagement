UPDATE employee
SET employment_status = true
WHERE id IN (1, 3); -- Employed employees

UPDATE employee
SET employment_status = false
WHERE id IN (2, 4); -- Not employed employees
