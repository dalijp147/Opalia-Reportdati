import React, { useEffect, useState } from "react";
import { MapContainer, TileLayer, Marker, Popup } from "react-leaflet";
import L from "leaflet";
import axios from "axios";

// Fix leaflet's default icon issue with React
delete L.Icon.Default.prototype._getIconUrl;
L.Icon.Default.mergeOptions({
  iconRetinaUrl:
    "https://unpkg.com/leaflet@1.7.1/dist/images/marker-icon-2x.png",
  iconUrl: "https://unpkg.com/leaflet@1.7.1/dist/images/marker-icon.png",
  shadowUrl: "https://unpkg.com/leaflet@1.7.1/dist/images/marker-shadow.png",
});

const MapComponent = () => {
  const [events, setEvents] = useState([]);

  useEffect(() => {
    axios
      .get("http://localhost:3001/event/")
      .then((response) => {
        setEvents(response.data.data);
      })
      .catch((error) => console.error("Error fetching event data:", error));
  }, []);

  const getCoordinates = (location) => {
    // Dummy implementation for converting location string to coordinates
    // Replace this with a real geocoding service for dynamic conversion
    const locations = {
      Tunis: [36.8065, 10.1815],
      Sfax: [34.7406, 10.7603],
      Sousse: [35.8256, 10.6369],
      Gabès: [33.8815, 10.0982],
    };
    return locations[location] || [33.8869, 9.5375]; // Default to Tunisia's coordinates
  };

  return (
    <MapContainer
      center={[33.8869, 9.5375]}
      zoom={6}
      style={{ height: "100px", width: "100px" }}
    >
      <TileLayer
        url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
        attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
      />
      {events.map((event) => (
        <Marker key={event.id} position={getCoordinates(event.location)}>
          <Popup>
            {event.name} <br /> {event.location}
          </Popup>
        </Marker>
      ))}
    </MapContainer>
  );
};

export default MapComponent;
