import { Component } from '@angular/core';

import { ZardButtonComponent } from '@shared/components/button/button.component';
import { ZardSkeletonComponent } from '@shared/components/skeleton/skeleton.component';
import { ContentComponent } from '@shared/components/layout/content.component';
import { FooterComponent } from '@shared/components/layout/footer.component';
import { HeaderComponent } from '@shared/components/layout/header.component';
import { LayoutComponent } from '@shared/components/layout/layout.component';
import { SidebarComponent, SidebarGroupComponent, SidebarGroupLabelComponent } from '@shared/components/layout/sidebar.component';
import { RouterModule } from '@angular/router';
import { LucideAngularModule, LayoutDashboard, Upload, GitCompare, c, Settings, FileText, History, LogOut } from "lucide-angular"

@Component({
  selector: 'z-demo-layout-full',
  standalone: true,
  imports: [
    RouterModule,
    LayoutComponent,
    HeaderComponent,
    ContentComponent,
    FooterComponent,
    SidebarComponent,
    SidebarGroupComponent,
    SidebarGroupLabelComponent,
    ZardButtonComponent,
    ZardSkeletonComponent,
    LucideAngularModule.pick({
      LayoutDashboard,
      Upload,
      GitCompare,
      AlertCircle,
      Settings,
      FileText,
      History,
      LogOut
    }),
  ],
  templateUrl: './dashboard.html',
})
export class Dashboard {
  year = new Date().getFullYear();
}
