import { bootstrapApplication } from '@angular/platform-browser';
import { App } from './app/app';
import { importProvidersFrom, ApplicationConfig } from '@angular/core';
import { LucideAngularModule, LayoutDashboard, Upload, GitCompare, CircleAlert, Settings, FileText, History, LogOut } from 'lucide-angular';
import { application } from 'express';

const appConfig: ApplicationConfig = {
  providers: [
    importProvidersFrom(
      LucideAngularModule.pick({
        LayoutDashboard,
        Upload,
        GitCompare,
        AlertCircle,
        Settings,
        FileText,
        History,
        LogOut
      })
    )
  ]
};

bootstrapApplication(application, appConfig);