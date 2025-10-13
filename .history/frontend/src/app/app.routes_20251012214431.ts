import { Routes } from '@angular/router';


export const routes: Routes = [
    { path: '', loadComponent: () => import('./pages/home/home').then(m => m.Home) },
    { path: 'about', loadComponent: () => import('./pages/login/login').then(m => m.Login) }
];
