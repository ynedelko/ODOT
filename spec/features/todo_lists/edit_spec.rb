require 'spec_helper'

describe "editing todo lists" do
  let!(:todo_list) {todo_list = TodoList.create(title: "Groceries", description: "Grocery list.")}
  def update_todo_list(options={})
    options[:title] ||= "My To Do List"
    options[:description] ||= "This is my To Do list."
    todo_list= options[:todo_list]

    visit "/todo_lists"
    within "#todo_list_#{todo_list.id}" do
      click_link "Edit"
    end

    fill_in "Title", with: options[:title]
    fill_in "Description", with: options[:description]
    click_button "Update Todo list"
  end

  it "updates a todo list successfully with correct information" do

    update_todo_list todo_list: todo_list,
                      title: "New Title",
                      description: "New Description"

    todo_list.reload

    expect(page).to have_content("Todo list was successfully updated")
    expect(todo_list.title).to eq("New Title")
    expect(todo_list.description).to eq("New Description")
  end

  it "displays an error with no title" do
    update_todo_list todo_list: todo_list, title: ""
    title = todo_list.title
    todo_list.reload
    expect(todo_list.title).to eq(title)
    expect(page).to have_content("error")
  end

  it "displays an error with too short a title" do
    update_todo_list todo_list: todo_list, title: "hi"
    expect(page).to have_content("error")
  end

  it "displays an error with no description" do
    update_todo_list todo_list: todo_list, description: ""
    expect(page).to have_content("error")
  end

  it "displays an error with too short a description" do
    update_todo_list todo_list: todo_list, description: "hi"
    expect(page).to have_content("error")
  end
end
