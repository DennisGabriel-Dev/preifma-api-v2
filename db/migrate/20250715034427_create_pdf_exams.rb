class CreatePdfExams < ActiveRecord::Migration[8.0]
  def change
    create_table :pdf_exams do |t|
      t.integer :year
      t.integer :type_pdf
      t.string :title
      t.string :url_jig
      t.string :url_exam

      t.timestamps
    end
  end
end
