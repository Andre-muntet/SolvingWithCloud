import express from "express";
import cors from "cors";
import authRouter from "./routes/auth.routes";
import pool from "./db";

const app = express();

app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
  res.json({ message: "Backend is running" });
});

app.use("/api", authRouter);

const port = 8080;

const startServer = async () => {
  try {

    await pool.query(`
      CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        email VARCHAR(255) UNIQUE NOT NULL,
        password VARCHAR(255) NOT NULL
      )
    `);

    console.log("Users table ready");

    app.listen(port, () => {
      console.log(`Backend running on port ${port}`);
    });

  } catch (error) {

    console.error("Failed to initialize database:", error);
    process.exit(1);

  }
};

startServer();