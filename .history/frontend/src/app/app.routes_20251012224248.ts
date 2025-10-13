// app.routes.ts
import { Routes } from '@angular/router';

export const routes: Routes = [
    { path: '', redirectTo: 'dashboard', pathMatch: 'full' },
    {
        path: 'dashboard',
        loadComponent: () =>
            import('./features/dashboard/pages/dashboard/dashboard').then(m => m.Dashboard)
    },
    {
        path: 'upload',
        loadComponent: () =>
            import('./features/reconciliation/pages/upload/upload.').then(m => m.Upload)
    },
    {
        path: 'matching',
        loadComponent: () =>
            import('./features/reconciliation/pages/matching-workspace/matching-workspace.').then(m => m.MatchingWorkspace)
    },
    {
        path: 'exceptions',
        loadComponent: () =>
            import('./features/reconciliation/pages/exceptions/exceptions.').then(m => m.Exceptions)
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
