import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import categoryRoutes from "./routes/categoryRoutes.js";
import transactionRoutes from "./routes/transactionRoutes.js";

dotenv.config();

const app = express();

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use("/api/categories", categoryRoutes);
app.use("/api/transactions", transactionRoutes);

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
