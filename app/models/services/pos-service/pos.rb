require 'aws-sdk'
require 'securerandom'
require 'json'
require 'dotenv/load'

def do_polling!
  # Create a client to receive and send messages
  sqs = Aws::SQS::Client.new(
    region: 'us-east-2',
    access_key_id: ENV['SQS_ACCESS_KEY_ID'],
    secret_access_key: ENV['SQS_SECRET_ACCESS_KEY']
  )
  # Where to tell the sqs client to receive messages from
  receive_queue_name = 'pos.fifo'
  receive_queue_url = sqs.get_queue_url(queue_name: receive_queue_name).queue_url

  puts 'continous polling beginning...'
  while true do
    # This grabs an array of 0 to 1 messages from the queue
    receive_message_result = sqs.receive_message({
      queue_url: receive_queue_url,
      message_attribute_names: ['All'], # Receive all custom attributes.
      max_number_of_messages: 1, # Receive at most one message.
      wait_time_seconds: 1 # Do not wait to check for the message.
    })

    if receive_message_result.messages.size.zero?
      # Wait 5 second between requests
      sleep 5
    end

    receive_message_result.messages.each do |message|
      puts "Received Message #{message.body}"

      puts 'Deleting Message from the Queue'
      sqs.delete_message({
        queue_url: receive_queue_url,
        receipt_handle: message.receipt_handle
      })
      puts 'Message removed'

      puts 'Sending order to dyanmo'
      insert_record(message.body)
      puts 'Completed request to dynamo'
    end
  end
end

def insert_record(message_body)
  order = JSON.parse(message_body.gsub("=>", ":"))
  dynamodb = Aws::DynamoDB::Client.new(
    region: 'us-east-2',
    access_key_id: ENV['DYNAMO_ACCESS_KEY_ID'],
    secret_access_key: ENV['DYNAMO_SECRET_ACCESS_KEY']
  )

  item = {
    id: order["id"],
    name: order["name"]
  }
  params = {
    table_name: "orders",
    item: item
  }

  begin
    dynamodb.put_item(params)
  rescue Aws::DynamoDB::Errors::ServiceError => error
    puts 'Unable to add movie:'
    puts error.message
  end
end

do_polling!
