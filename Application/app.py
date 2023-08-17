from flask import Flask, render_template, request, redirect, url_for
import psycopg2

app = Flask(__name__)

# Database connection parameters
db_params = {
    "dbname": "myhadmdq",
    "user": "myhadmdq",
    "password": "EO6-iHzoVwXUkBYfFlsuAYi3O5kx41X9",
    "host": "john.db.elephantsql.com",
    "port": "5432",
}




@app.route('/')
def index():
    conn = psycopg2.connect(**db_params)
    cursor = conn.cursor()

    select_query = "SELECT id, name, salary FROM employee"
    cursor.execute(select_query)
    employees = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template('index.html', employees=employees)


@app.route('/update/<int:id>', methods=['POST'])
def update_employee(id):
    try:
        new_salary = int(request.form['new_salary'])
        conn = psycopg2.connect(**db_params)
        cursor = conn.cursor()

        update_query = """
        UPDATE employee
        SET salary = %s
        WHERE id = %s
        """

        cursor.execute(update_query, (new_salary, id))
        conn.commit()

        cursor.close()
        conn.close()

        return redirect(url_for('index'))
    except (Exception, psycopg2.DatabaseError) as error:
        print("Error updating salary:", error)
        return "Error updating salary"



if __name__ == '__main__':
    app.run(debug=True)
