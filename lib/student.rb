require_relative "../config/environment.rb"
require 'pry'

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name, :id, :grade

  def initialize(name=nil, grade=nil, id = nil)
  	@name = name
  	@grade = grade
  	@id = id
  end

  def self.create_table
  	sql = <<-SQL
  	CREATE TABLE students (id INTEGER PRIMARY KEY,
  	name TEXT
  	grade INTEGER);
  	SQL
  	DB[:conn].execute(sql)
  end

  def self.drop_table
  	sql = <<-SQL
  	DROP TABLE students;
  	SQL
  	DB[:conn].execute(sql)
  end

  def self.create(name, grade)
  	student = Student.new(name, grade)
  	student.save
  	student
  end


  def save
  	if self.id
  		self.update
  	else sql = <<-SQL
		INSERT INTO students (name, grade)
		VALUES (?, ?)
	    SQL
	  DB[:conn].execute(sql, self.name, self.grade)

		sql = <<-SQL
	  	SELECT id
	  	FROM students
	  	ORDER BY id DESC
	  	LIMIT 1;
	  	SQL
	  	resulting_id = DB[:conn].execute(sql)
	  	@id = resulting_id.first
	  end

  end



  def self.new_from_db(row)
	new_student = self.new
	new_student.id = row[0]
	new_student.name = row[1]
	new_student.grade = row[2]
	new_student
  end

  def self.find_by_name(name)
  	sql = <<-SQL
    SELECT *
    FROM students
    WHERE name = ?
    SQL
    each_row = DB[:conn].execute(sql,name).first
    self.new_from_db(each_row)
  end

  def update
  	sql = <<-SQL
  	UPDATE students
  	SET name = ?, grade = ?
  	WHERE id = ?;
  	SQL
  	DB[:conn].execute(sql, self.name, self.grade, self.id)
  end


end
