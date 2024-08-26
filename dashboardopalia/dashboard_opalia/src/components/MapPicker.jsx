import React, { useState } from "react";
import { MapContainer, TileLayer, Marker, useMapEvents } from "react-leaflet";
import L from "leaflet";

// Fixing the default icon issue with Leaflet
delete L.Icon.Default.prototype._getIconUrl;
L.Icon.Default.mergeOptions({
  iconRetinaUrl:
    "https://unpkg.com/leaflet@1.7.1/dist/images/marker-icon-2x.png",
  iconUrl: "https://unpkg.com/leaflet@1.7.1/dist/images/marker-icon.png",
  shadowUrl: "https://unpkg.com/leaflet@1.7.1/dist/images/marker-shadow.png",
});

const MapPicker = ({
  onLocationSelect,
  mapHeight = "200px",
  mapWidth = "100%",
}) => {
  const [selectedLocation, setSelectedLocation] = useState({
    lat: 33.886917, // Default latitude for Tunisia
    lng: 9.537499, // Default longitude for Tunisia
  });

  const MapClickHandler = () => {
    useMapEvents({
      click: (e) => {
        setSelectedLocation(e.latlng);
        onLocationSelect(e.latlng);
      },
    });
    return selectedLocation ? (
      <Marker position={selectedLocation}></Marker>
    ) : null;
  };

  return (
    <MapContainer
      center={[33.886917, 9.537499]} // Center map on Tunisia
      zoom={7} // Zoom level adjusted for Tunisia
      style={{ height: mapHeight, width: mapWidth }}
    >
      <TileLayer
        url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
        attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
      />
      <MapClickHandler />
    </MapContainer>
  );
};

export default MapPicker;
