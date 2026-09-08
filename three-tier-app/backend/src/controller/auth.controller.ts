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
      message: "Incorrect emaiili or password yeah"
    });
  }

  return res.json({
    success: true,
    message: "Login successful"
  });
};