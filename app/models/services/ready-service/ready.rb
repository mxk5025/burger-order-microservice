# frozen_string_literal: true

require 'aws-sdk'
require 'http'
require 'securerandom'
require 'json'
require 'dotenv/load'

COMPLETED_ENDPOINT = "http://3.136.108.141/orders/receive_completed"

def do_polling!
  # Create a client to receive and send messages
  sqs = Aws::SQS::Client.new(
    region: 'us-east-2',
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
  )
  # Where to tell the sqs client to receive messages from
  receive_queue_name = 'ready.fifo'
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

      puts 'Kicks off timer to simulate Wrapping'
      sleep 2
      puts 'Order completed'

      puts 'Sending completion message to Front End'
      post_to_frontend(message.body)
      puts 'Completed request to Front End'
    end
  end
end

def post_to_frontend(message_body)
  # The AWS SDK returns a hash rocket like syntax,
  # {
  #   "id" => "123"
  # }
  # JSON.parse expects a key:value without hash rocket,
  # {
  #   "id": "123"
  # }
  # So to get the id, we replace the '=>' with ':', parse it to
  # return a key-value hash and then grab the hash's id
  id = JSON.parse(message_body.gsub("=>", ":"))["id"]
  HTTP.post(COMPLETED_ENDPOINT, json: {
    id: id
  })
end
# When run, the microservice just runs the while true loop in do_polling
do_polling!
