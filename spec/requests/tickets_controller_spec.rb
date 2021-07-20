require "rails_helper"

RSpec.describe "Create a Ticket", :type => :request do

  # valid cases ----------------------------------------------------------------------------
  it "post a valid ticket without tags" do
    post "/tickets", params: { "ticket": { "user_id": "34", "title": "Hi Joe" } }
    expect(response.content_type).to eq("application/json; charset=utf-8")
    expect(response).to have_http_status(:ok)
    ticket = Ticket.first
    expect(Ticket.all.count).to eq(1)
    expect(ticket.user_id).to eq(34)
    expect(ticket.title).to eq("Hi Joe")
  end

  it "post a valid ticket with tags" do
    post "/tickets", params: { "ticket": { "user_id": "34", "title": "Hi Joe", tags: [1,2,3,4] } }
    post "/tickets", params: { "ticket": { "user_id": "56", "title": "Hi Pam", tags: [3] } }
    expect(response.content_type).to eq("application/json; charset=utf-8")
    expect(response).to have_http_status(:ok)
    expect(Ticket.all.count).to eq(2)
    ticket = Ticket.first
    ticket2 = Ticket.second
    expect(ticket.user_id).to eq(34)
    expect(ticket.title).to eq("Hi Joe")
    expect(ticket2.user_id).to eq(56)
    expect(ticket2.title).to eq("Hi Pam")
    expect(Tag.all.map {|t| t.name}).to eq(["1","2","3","4"])
    expect(Tag.all.size).to eq(4)
    top_tag = Tag.top_tag
    expect(top_tag.name).to eq("3")
    expect(top_tag.count).to eq(2)
  end

  # invalid cases without tags --------------------------------------------------------------
  it "post a ticket with an invalid user_id key without tags" do
    post "/tickets", params: { "ticket": { "useX_id": "34", "title": "Hi Joe" } }
    expect(response.content_type).to eq("application/json; charset=utf-8")
    json = JSON.parse(response.body)
    expect(json["error"]).to eq(["User can't be blank","User is not a number"])
  end

  it "post a ticket with an invalid user_id value without tags" do
    post "/tickets", params: { "ticket": { "user_id": "cool", "title": "Hi Joe" } }
    expect(response.content_type).to eq("application/json; charset=utf-8")
    expect(response).to have_http_status(:unprocessable_entity)
    json = JSON.parse(response.body)
    expect(json["error"]).to eq(["User is not a number"])
  end

  it "post a ticket with an invalid title key without tags" do
    post "/tickets", params: { "ticket": { "user_id": "34", "Xitle": "Hi Joe" } }
    expect(response.content_type).to eq("application/json; charset=utf-8")
    expect(response).to have_http_status(:unprocessable_entity)
    json = JSON.parse(response.body)
    expect(json["error"]).to eq(["Title can't be blank"])
  end

  it "post a ticket with an invalid user_id and title keys without tags" do
    post "/tickets", params: { "ticket": { "useX_id": "34", "Xitle": "Hi Joe" } }
    expect(response.content_type).to eq("application/json; charset=utf-8")
    expect(response).to have_http_status(:unprocessable_entity)
    json = JSON.parse(response.body)
    expect(json["error"]).to eq(["User can't be blank", "User is not a number", "Title can't be blank"])
  end
  
  # invalid cases with tags
  it "post a ticket with an invalid user_id key with tags" do
    post "/tickets", params: { "ticket": { "useX_id": "34", "title": "Hi Joe", tags: [1,2,3,4] } }
    expect(response.content_type).to eq("application/json; charset=utf-8")
    expect(response).to have_http_status(:unprocessable_entity)
    json = JSON.parse(response.body)
    expect(json["error"]).to eq(["User can't be blank", "User is not a number"])
  end

  it "post a ticket with an invalid title key with tags" do
    post "/tickets", params: { "ticket": { "user_id": "34", "Xitle": "Hi Joe", tags: [1,2,3,4] } }
    expect(response.content_type).to eq("application/json; charset=utf-8")
    expect(response).to have_http_status(:unprocessable_entity)
    json = JSON.parse(response.body)
    expect(json["error"]).to eq(["Title can't be blank"])
  end

  it "post a ticket with an invalid user_id and title keys with tags" do
    post "/tickets", params: { "ticket": { "useX_id": "34", "Xitle": "Hi Joe", tags: [1,2,3,4] } }
    expect(response.content_type).to eq("application/json; charset=utf-8")
    expect(response).to have_http_status(:unprocessable_entity)
    json = JSON.parse(response.body)
    expect(json["error"]).to eq(["User can't be blank", "User is not a number", "Title can't be blank"])
  end

  it "post a valid ticket with too many tags" do
    post "/tickets", params: { "ticket": { "user_id": "34", "title": "Hi Joe", tags: [1,2,3,4,5,6] } }
    expect(response.content_type).to eq("application/json; charset=utf-8")
    expect(response).to have_http_status(:unprocessable_entity)
    json = JSON.parse(response.body)
    expect(json["error"]).to eq("More than 5 tags submitted.")
  end
end

