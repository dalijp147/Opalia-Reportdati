import React, { useEffect, useState } from "react";
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
} from "recharts";
import axios from "axios";

const ChartttComponent = () => {
  const [data, setData] = useState([]);
  const baseUrl = "http://localhost:3001";

  useEffect(() => {
    const fetchEventData = async () => {
      try {
        const eventResponse = await axios.get(`${baseUrl}/event/`);
        const events = eventResponse.data.data;

        const eventDataPromises = events.map(async (event) => {
          const participantResponse = await axios.get(
            `${baseUrl}/participant/participon/${event._id}`
          );
          const participant = participantResponse.data.length;

          return {
            eventName: event.eventname,
            participant: participant,
          };
        });

        const eventData = await Promise.all(eventDataPromises);
        console.log("Mapped event data for chart:", eventData);
        setData(eventData);
      } catch (error) {
        console.error("Error fetching event or participant data:", error);
      }
    };

    fetchEventData();
  }, []);

  return (
    <ResponsiveContainer width="100%" height={450}>
      <BarChart data={data}>
        <CartesianGrid strokeDasharray="5 5" />
        <XAxis dataKey="eventName" />
        <YAxis
          allowDecimals={false} // This ensures the Y-axis shows only integer values
          tickFormatter={(value) => (Number.isInteger(value) ? value : "")} // Further ensures no floating numbers
        />
        <Tooltip />
        <Legend />
        <Bar dataKey="participant" fill="red" />
      </BarChart>
    </ResponsiveContainer>
  );
};

export default ChartttComponent;
