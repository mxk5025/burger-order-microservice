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
    const orderId = data.content.order.id;
    switch (action) {
      case 'order_placed':
        // Reset the Order Form
        $('#new_order').trigger('reset');

        // Update the Order Id for next order
        let newId = data.content.next_id
        $('#order_id').val(newId);

        // Add the Order to the Placed list
        $('#Placed-list').append(createOrderItem(data.content.order));
        break;
      case 'order_grilled':
        console.log('order grilled');
        $("#list-item-" + orderId).detach().appendTo('#Grilled-list');
        break;
      case 'order_condiments_applied':
        console.log('order condiments')
        $("#list-item-" + orderId).detach().appendTo('#Condiments-list');
        // move list item around
        break;
      case 'order_wrapped':
        $("#list-item-" + orderId).detach().appendTo('#Wrapped-list');
        console.log('order wrapped')
        // move list item around
        break;
      case 'order_completed':
        $("#list-item-" + orderId).detach().appendTo('#Completed-list');
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

  $("#list-item-" + orderId).children()[0].innerText = "Completed in " + elapsed + " seconds";
}

const createOrderItem = (order) => {
  const orderId = order.id;
  const orderName = order.name;
  const time = new Date().getTime();
  return "<li class='OrderItem' id='list-item-" + orderId + "' data-time=" + time + ">" + orderName + "'s Order " + " <span>(Pending)</span></li>";
}