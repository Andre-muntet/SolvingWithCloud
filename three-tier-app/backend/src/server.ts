import express from "express";
import cors from "cors";
import authRouter from "./routes/auth.routes";

const app = express();

app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
  res.json({ message: "Backend is running" });
});

app.use("/api", authRouter);

const port = 8080;

app.listen(port, () => {
  console.log(`Backend running on http://localhost:${port}`);
});