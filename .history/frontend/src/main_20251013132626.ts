import { bootstrapApplication } from '@angular/platform-browser';
import { appConfig } from './app/app.config';
import { App } from './app/app';
import { importProvidersFrom } from '@angular/core';
import { LucideAngularModule, LayoutDashboard, Upload, GitCompare, CircleAlert, Settings, FileText, History, LogOut } from 'lucide-angular';

bootstrapApplication(App, appConfig)
  .catch((err) => console.error(err));
