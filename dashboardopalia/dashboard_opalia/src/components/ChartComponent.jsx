import React from "react";
import { Doughnut, Pie } from "react-chartjs-2";
import { Chart as ChartJS, ArcElement, Tooltip, Legend } from "chart.js";
import { Typography } from "antd";
ChartJS.register(ArcElement, Tooltip, Legend);

const ChartComponent = ({ doctors, patients }) => {
  const data = {
    labels: ["Docteurs", "Patients"],
    datasets: [
      {
        data: [doctors, patients],
        backgroundColor: ["rgb(250, 121, 121)", "white"],
        borderColor: ["rgb(250, 121, 121)", "rgb(250, 121, 121)"],
        borderWidth: 2,
      },
    ],
  };

  return (
    <div style={{ height: "350px", width: "500px", alignItems: "center" }}>
      <h2>Chart qui représente le nombre d'utilisateurs.</h2>
      <Doughnut data={data} />
    </div>
  );
};

export default ChartComponent;
