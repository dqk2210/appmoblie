import express from 'express';
import {
  getTransactions,
  createTransaction,
  updateTransaction,
  deleteTransaction,
} from '../controller/transactionController.js';

const router = express.Router();

router.get('/', getTransactions);
router.post('/', createTransaction);
router.put('/:id', updateTransaction);
router.delete('/:id', deleteTransaction);

export default router;
