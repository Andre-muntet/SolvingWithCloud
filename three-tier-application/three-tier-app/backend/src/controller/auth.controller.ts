import { Request, Response } from "express";
import pool from "../db";

export const login = async (req: Request, res: Response) => {
  const { email, password } = req.body;

  console.log("Login request:", email);

  const result = await pool.query("SELECT * FROM users WHERE email = $1", [email]);

  const user = result.rows[0];

  if (!user || user.password !== password) {
    return res.status(401).json({
      success: false,
      message: "Incorrect email or password"
    });
  }

  return res.json({
    success: true,
    message: "Login successful"
  });
};

export const signup = async (req: Request, res: Response) => {

  const { email, password } = req.body;

  console.log("Signup request:", email);

  const result = await pool.query(
    "SELECT * FROM users WHERE email = $1",
    [email]
  );

  const user = result.rows[0];

  if (user) {
    return res.status(409).json({
      success: false,
      message: "Email already exists"
    });
  }

  await pool.query(
    "INSERT INTO users (email, password) VALUES ($1, $2)",
    [email, password]
  );

  return res.json({
    success: true,
    message: "Signup successful"
  });
};