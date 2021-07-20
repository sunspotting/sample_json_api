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
  it "post a ticket with an invalid user_id without tags" do
    post "/tickets", params: { "ticket": { "useX_id": "34", "title": "Hi Joe" } }
    expect(response.content_type).to eq("application/json; charset=utf-8")
    expect(response).to have_http_status(:unprocessable_entity)
  end

  it "post a ticket with an invalid user_id without tags" do
    post "/tickets", params: { "ticket": { "user_id": "cool", "title": "Hi Joe" } }
    expect(response.content_type).to eq("application/json; charset=utf-8")
    expect(response).to have_http_status(:unprocessable_entity)
  end

  it "post a ticket with an invalid title without tags" do
    post "/tickets", params: { "ticket": { "user_id": "34", "Xitle": "Hi Joe" } }
    expect(response.content_type).to eq("application/json; charset=utf-8")
    expect(response).to have_http_status(:unprocessable_entity)
  end

  it "post a ticket with an invalid user_id and title without tags" do
    post "/tickets", params: { "ticket": { "useX_id": "34", "Xitle": "Hi Joe" } }
    expect(response.content_type).to eq("application/json; charset=utf-8")
    expect(response).to have_http_status(:unprocessable_entity)
  end
  
  # invalid cases with tags
  it "post a ticket with an invalid user_id with tags" do
    post "/tickets", params: { "ticket": { "useX_id": "34", "title": "Hi Joe", tags: [1,2,3,4] } }
    expect(response.content_type).to eq("application/json; charset=utf-8")
    expect(response).to have_http_status(:unprocessable_entity)
  end

  it "post a ticket with an invalid title with tags" do
    post "/tickets", params: { "ticket": { "user_id": "34", "Xitle": "Hi Joe", tags: [1,2,3,4] } }
    expect(response.content_type).to eq("application/json; charset=utf-8")
    expect(response).to have_http_status(:unprocessable_entity)
  end

  it "post a ticket with an invalid user_id and title with tags" do
    post "/tickets", params: { "ticket": { "useX_id": "34", "Xitle": "Hi Joe", tags: [1,2,3,4] } }
    expect(response.content_type).to eq("application/json; charset=utf-8")
    expect(response).to have_http_status(:unprocessable_entity)
  end

  it "post a ticket with a valid ticket with too many tags" do
    post "/tickets", params: { "ticket": { "user_id": "34", "title": "Hi Joe", tags: [1,2,3,4,5,6] } }
    expect(response.content_type).to eq("application/json; charset=utf-8")
    expect(response).to have_http_status(:unprocessable_entity)
  end
end

