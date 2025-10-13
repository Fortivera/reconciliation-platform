import { bootstrapApplication } from '@angular/platform-browser';
import { appConfig } from './app/app.config';
import { App } from './app/app';
import { provideRouter } from '@angular/router';
import { routes } from './app/app.routes';

bootstrapApplication(App, appConfig, {
  providers: [
    ...provideRouter(routes) // <-- spread the EnvironmentProviders into an array of Provider
  ] })
  .catch((err) => console.error(err));
