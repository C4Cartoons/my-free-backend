const express = require('express'); 
const { createClient } = require('@supabase/supabase-js');
const app = express(); 
app.use(express.json());
const PORT = process.env.PORT || 3000; 
const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_KEY
 );
app.get('/', (req, res) => {
  res.json({ status: 'Online', message: 'Backend and Supabase connected!' });
 });
app.get('/items', async (req, res) => {
  const { data, error } = await supabase.from('items').select('*');
  if (error) return res.status(500).json({ error: error.message });
  res.json(data);
 });
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
 });
