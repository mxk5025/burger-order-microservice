import consumer from "./consumer"


consumer.subscriptions.create("OrderScreenChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("Connected to the room!");
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    const action = data.content.action;

    switch (action) {
      case 'order_placed':
        // Reset the Order Form
        $('#new_order').trigger('reset');

        // Update the Order Id for next order
        let newId = data.content.next_id
        $('#order_id').val(newId);

        // Add the Order to the Placed list
        $('#orders-list').append(createOrderItem(data.content.order));
        break;
      case 'order_grilled':
        console.log('order grilled')
        // move list item around
        break;
      case 'order_condiments_applied':
        console.log('order condiments')
        // move list item around
        break;
      case 'order_wrapped':
        console.log('order wrapped')
        // move list item around
        break;
      case 'order_completed':
        console.log('order has been marked completed');
        completeOrderItem(data.content.order);
        break;
      default:
        console.log("unknown action");
        break;
    }
  }
});

const completeOrderItem = (order) => {
  const orderId = order.id;

  const endTime = new Date().getTime();
  const startTime = $('#list-item-' + orderId).data().time;

  const elapsed = (endTime - startTime) / 1000;

  $("#list-item-" + orderId).children()[0].innerText = "Completed. Took " + elapsed + " seconds for completion";
}

const createOrderItem = (order) => {
  const orderId = order.id;
  const orderName = order.name;
  const time = new Date().getTime();
  return "<li id='list-item-" + orderId + "' data-time=" + time + ">Order: " + orderName + " Status:  <span>Pending</span></li>";
}