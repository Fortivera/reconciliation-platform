import { bootstrapApplication } from '@angular/platform-browser';
import { appConfig } from './app/app.config';
import { App } from './app/app';
import {
  LucideAngularModule,
  LayoutDashboard,
  Upload,
  GitCompare,
  circ,
  Settings,
  FileText,
  History,
  LogOut
} from 'lucide-angular';
bootstrapApplication(App, appConfig,
  {
    providers: [
      // Use importProvidersFrom to configure the Lucide icons at the application level
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
        }
)
  .catch((err) => console.error(err));
