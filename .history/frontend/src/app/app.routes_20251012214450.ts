import { Routes } from '@angular/router';


export const routes: Routes = [
    { path: '', loadComponent: () => import('.').then(m => m.App) },
    { path: 'about', loadComponent: () => import('./pages/login/login').then(m => m.Login) }
];
