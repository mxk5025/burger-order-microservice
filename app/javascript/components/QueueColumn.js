import React from "react";
import Typography from '@material-ui/core/Typography';

export default function QueueColumn({name}) {
  return (
    <div className="Orders">
      <Typography variant="h5" component="h5" align="center">
        {name} Status
      </Typography>
      <ul id={name + "-list"} className="OrderColumn">
      </ul>
    </div>
  );
}
