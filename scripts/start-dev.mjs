import { dev } from 'astro';

try {
  console.log('Starting Astro dev server...');
  const server = await dev({
    root: process.cwd(),
    server: {
      host: '127.0.0.1',
      port: 4321
    }
  });
  console.log('Server successfully running!');
} catch (err) {
  console.error('Error starting server:', err);
}
