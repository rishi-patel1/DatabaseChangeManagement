DELETE FROM employee
WHERE id = (
    SELECT id
    FROM employee
    ORDER BY id DESC
    LIMIT 1
);
