import { NgModule } from '@angular/core';
import { LucideAngularModule, LayoutDashboard, Upload, GitCompare, CircleAlert, Settings, FileText, History, LogOut, Search, , Trash2, Plus, SettingsIcon } from 'lucide-angular';

@NgModule({
    imports: [
        LucideAngularModule.pick({
            LayoutDashboard,
            Upload,
            GitCompare,
            CircleAlert,
            Settings,
            FileText,
            History,
            LogOut,
        }),
    ],
    exports: [LucideAngularModule] 
})
export class LucideIconsModule { }
