// app.routes.ts
import { Routes } from '@angular/router';

export const routes: Routes = [
    { path: '', redirectTo: 'dashboard', pathMatch: 'full' },
    {
        path: 'dashboard',
        loadComponent: () =>
            import('./features/dashboard/pages/dashboard/dashboard').then(m => m.DashboardComponent)
    },
    {
        path: 'upload',
        loadComponent: () =>
            import('./features/reconciliation/pages/upload/upload.component').then(m => m.UploadComponent)
    },
    {
        path: 'matching',
        loadComponent: () =>
            import('./features/reconciliation/pages/matching-workspace/matching-workspace.component').then(m => m.MatchingWorkspaceComponent)
    },
    {
        path: 'exceptions',
        loadComponent: () =>
            import('./features/reconciliation/pages/exceptions/exceptions.component').then(m => m.ExceptionsComponent)
    },
    {
        path: 'rules',
        loadComponent: () =>
            import('./features/reconciliation/pages/rules/rules.component').then(m => m.RulesComponent)
    },
    {
        path: 'audit-trail',
        loadComponent: () =>
            import('./features/reconciliation/pages/audit-trail/audit-trail.component').then(m => m.AuditTrailComponent)
    },
    {
        path: 'reports',
        loadComponent: () =>
            import('./features/reconciliation/pages/reports/reports.component').then(m => m.ReportsComponent)
    },
    {
        path: 'login',
        loadComponent: () =>
            import('./features/auth/pages/login/login.component').then(m => m.LoginComponent)
    }
];
