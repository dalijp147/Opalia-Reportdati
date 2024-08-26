import { useState } from "react";
import { useLogin } from "../../hooks/useLogin";
import "./login.css"; // Import the CSS file for styling
import { Link } from "react-router-dom";
const Login = () => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const { login, error, isLoading } = useLogin();
  const [passwordVisible, setPasswordVisible] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!email || !password) {
      alert("Please fill out all fields.");
      return;
    }
    await login(email, password);
  };

  return (
    <div className="login-container">
      <form className="login-form" onSubmit={handleSubmit}>
        <h3>Se connecter</h3>

        <label>Email:</label>
        <input
          type="email"
          onChange={(e) => setEmail(e.target.value)}
          value={email}
          required
        />
        <label>Mot de Passe:</label>
        <input
          type={passwordVisible ? "text" : "password"}
          onChange={(e) => setPassword(e.target.value)}
          value={password}
          required
        />
        <button
          type="button"
          onClick={() => setPasswordVisible(!passwordVisible)}
        >
          {passwordVisible ? "Cacher" : "Montrer"} Mot de Passe
        </button>
        <label></label>
        <button disabled={isLoading} type="submit">
          {isLoading ? "Loading..." : "Se connecter"}
        </button>
        {error && <div className="error">{error}</div>}
        <div className="signup-link">
          <p>tu as un compte?</p>
          <Link to="/signup">
            <button type="button" className="signup-button">
              Sign Up
            </button>
          </Link>
        </div>
      </form>
    </div>
  );
};

export default Login;
