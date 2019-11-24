import React from "react";
import Typography from '@material-ui/core/Typography';

export default function Orders() {
  return (
    <div className="Orders">
      <Typography variant="h5" component="h5" align="center">
        Order Status
      </Typography>
      <ul id="orders-list">
      </ul>
    </div>
  );
}
