import { bootstrapApplication } from '@angular/platform-browser';
import { appConfig } from './app/app.config';
import { App } from './app/app';
import { provideRouter } from '@angular/router';
import { routes } from './app/app.routes';

bootstrapApplication(App, appConfig, [
  provideRouter(routes) // <-- pass as array directly
])
  .catch((err) => console.error(err));
