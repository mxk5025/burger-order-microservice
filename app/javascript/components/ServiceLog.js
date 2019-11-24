import React from "react";
import Typography from '@material-ui/core/Typography';

export default function ServiceLog() {
  return (
    <div className="ServiceLog">
      <Typography variant="h5" component="h5" align="center">
        Service Status
      </Typography>
      <ul id="service-log-list">
      </ul>
    </div>
  );
}
