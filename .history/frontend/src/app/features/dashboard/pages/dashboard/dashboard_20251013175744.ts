import { Component } from '@angular/core';

import { ZardButtonComponent } from '@shared/components/button/button.component';
import { ZardSkeletonComponent } from '@shared/components/skeleton/skeleton.component';
import { ContentComponent } from '@shared/components/layout/content.component';
import { FooterComponent } from '@shared/components/layout/footer.component';
import { HeaderComponent } from '@shared/components/layout/header.component';
import { ZardAvatarComponent } from  '@shared/components/avatar/avatar.component';
import { LayoutComponent } from '@shared/components/layout/layout.component';
import { SidebarComponent, SidebarGroupComponent, SidebarGroupLabelComponent } from '@shared/components/layout/sidebar.component';
import { RouterModule, Router } from '@angular/router';
import { LucideIconsModule } from '@shared/modules/lucide-icons.module';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [
    RouterModule,
    CommonModule, 
    LayoutComponent,
    HeaderComponent,
    ContentComponent,
    FooterComponent,
    SidebarComponent,
    SidebarGroupComponent,
    SidebarGroupLabelComponent,
    ZardButtonComponent,
    ZardSkeletonComponent,
    // ZardAvatarComponent,
    LucideIconsModule,
  ],
  templateUrl: './dashboard.html',
})
export class Dashboard {
  constructor(public router: Router) { }
}
