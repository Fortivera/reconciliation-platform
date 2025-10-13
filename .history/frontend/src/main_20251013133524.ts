import { bootstrapApplication } from '@angular/platform-browser';
import { App } from './app/app';
import { importProvidersFrom } from '@angular/core';
import { LucideAngularModule, LayoutDashboard, Upload, GitCompare, CircleAlert, Settings, FileText, History, LogOut } from 'lucide-angular';

bootstrapApplication(App, {
  providers: [
    // This injects the icons themselves into the application.
    importProvidersFrom(
      LucideAngularModule.pick({
        LayoutDashboard,
        Upload,
        GitCompare,
        CircleAlert,
        Settings,
        FileText,
        History,
        LogOut
      })
    )
  ]
});