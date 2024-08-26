import { useState } from "react";
import { useSignup } from "../../hooks/useSignup";
import { Link } from "react-router-dom"; // Import Link from React Router
import "./signup.css";
const Signup = () => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const { signup, error, isLoading } = useSignup();

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!email || !password) {
      alert("Please fill out all fields.");
      return;
    }

    await signup(email, password);
  };

  return (
    <div className="signup-container">
      <form className="signup-form" onSubmit={handleSubmit}>
        <h3>Créer un Compte</h3>

        <label>Email:</label>
        <input
          type="email"
          onChange={(e) => setEmail(e.target.value)}
          value={email}
          required
        />
        <label>Mot de passe:</label>
        <input
          type="password"
          onChange={(e) => setPassword(e.target.value)}
          value={password}
          required
        />

        <button disabled={isLoading} type="submit">
          {isLoading ? "Loading..." : "Création"}
        </button>

        {error && <div className="error">{error}</div>}

        {/* Login Button */}
        <div className="login-link">
          <p>se connecter</p>
          <Link to="/login">
            <button type="button" className="login-button">
              Connecter
            </button>
          </Link>
        </div>
      </form>
    </div>
  );
};

export default Signup;
